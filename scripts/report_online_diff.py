#!/usr/bin/env python3
"""Report local working tree differences against the online upstream branch."""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def run(args: list[str], *, text: bool = True) -> str:
    return subprocess.check_output(args, cwd=ROOT, text=text)


def git(args: list[str]) -> str:
    return run(["git", *args])


def shell_quote(value: str) -> str:
    return value.replace("`", "\\`")


def is_binary_path(path: Path) -> bool:
    try:
        data = path.read_bytes()[:8192]
    except OSError:
        return False
    return b"\0" in data


def file_size(path: Path) -> int | None:
    try:
        return path.stat().st_size
    except OSError:
        return None


def upstream_for_arg() -> str:
    if len(sys.argv) > 1:
        return sys.argv[1]
    upstream = subprocess.run(
        ["git", "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}"],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
    ).stdout.strip()
    if upstream:
        return upstream
    for candidate in ("origin/main", "origin/master"):
        result = subprocess.run(
            ["git", "rev-parse", "--verify", candidate],
            cwd=ROOT,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        if result.returncode == 0:
            return candidate
    raise SystemExit("Could not determine upstream online branch.")


def changed_paths(upstream: str) -> list[str]:
    tracked = git(["diff", "--name-only", upstream]).splitlines()
    untracked = git(["ls-files", "--others", "--exclude-standard"]).splitlines()
    return sorted(dict.fromkeys([*tracked, *untracked]))


def old_size(upstream: str, path: str) -> int | None:
    result = subprocess.run(
        ["git", "cat-file", "-s", f"{upstream}:{path}"],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
    )
    if result.returncode != 0:
        return None
    try:
        return int(result.stdout.strip())
    except ValueError:
        return None


def binary_from_numstat(upstream: str, path: str) -> bool:
    result = subprocess.run(
        ["git", "diff", "--numstat", upstream, "--", path],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
    )
    return result.stdout.startswith("-\t-")


def print_binary(upstream: str, path: str, status: str) -> None:
    local = ROOT / path
    before = old_size(upstream, path)
    after = file_size(local)
    source = "regenerated from LaTeX" if path == "files/CV_Yilie_Huang.pdf" else "copied manually or binary source not identified"
    preview = ""
    if path.startswith("files/"):
        preview = f"; preview http://127.0.0.1:4000/{path}"
    size_text = f"old size {before if before is not None else 'unavailable'} bytes; new size {after if after is not None else 'unavailable'} bytes"
    print(f"* `{path}`: {status} binary file; {size_text}; {source}{preview}")


HUNK_RE = re.compile(r"@@ -(?P<old>\d+)(?:,\d+)? \+(?P<new>\d+)(?:,\d+)? @@")


def report_tracked_text(upstream: str, path: str) -> None:
    diff = git(["diff", "--unified=0", "--no-ext-diff", upstream, "--", path]).splitlines()
    old_line = new_line = 0
    removed: list[tuple[int, str]] = []
    added: list[tuple[int, str]] = []

    def flush() -> None:
        nonlocal removed, added
        pairs = min(len(removed), len(added))
        for index in range(pairs):
            old_no, old_text = removed[index]
            new_no, new_text = added[index]
            if not old_text.strip() and not new_text.strip():
                continue
            print(f"* `{path}:{new_no}`: changed from `{shell_quote(old_text)}` to `{shell_quote(new_text)}`")
        for old_no, old_text in removed[pairs:]:
            if not old_text.strip():
                continue
            print(f"* `{path}:{old_no}`: removed `{shell_quote(old_text)}`")
        for new_no, new_text in added[pairs:]:
            if not new_text.strip():
                continue
            print(f"* `{path}:{new_no}`: added `{shell_quote(new_text)}`")
        removed = []
        added = []

    for line in diff:
        match = HUNK_RE.match(line)
        if match:
            flush()
            old_line = int(match.group("old"))
            new_line = int(match.group("new"))
            continue
        if line.startswith(("---", "+++")) or line.startswith("diff --git") or line.startswith("index "):
            continue
        if line.startswith("-"):
            removed.append((old_line, line[1:]))
            old_line += 1
            continue
        if line.startswith("+"):
            added.append((new_line, line[1:]))
            new_line += 1
            continue
        flush()
        if line.startswith(" "):
            old_line += 1
            new_line += 1
    flush()


def report_untracked_text(path: str) -> None:
    local = ROOT / path
    try:
        lines = local.read_text(encoding="utf-8").splitlines()
    except UnicodeDecodeError:
        print_binary("", path, "new")
        return
    for line_no, line in enumerate(lines, start=1):
        if not line.strip():
            continue
        print(f"* `{path}:{line_no}`: added `{shell_quote(line)}`")


def main() -> None:
    upstream = upstream_for_arg()
    tracked = set(git(["diff", "--name-only", upstream]).splitlines())
    for path in changed_paths(upstream):
        local = ROOT / path
        if path in tracked:
            if binary_from_numstat(upstream, path):
                print_binary(upstream, path, "modified")
            else:
                report_tracked_text(upstream, path)
        else:
            if is_binary_path(local):
                print_binary(upstream, path, "new")
            else:
                report_untracked_text(path)


if __name__ == "__main__":
    main()
