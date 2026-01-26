---
permalink: /
title: "About me"
author_profile: true
redirect_from: 
  - /about/
  - /about.html
---

Yilie Huang is a Postdoctoral Research Scientist in the Department of Industrial Engineering and Operations Research at Columbia University, supervised by [Professor Xun Yu Zhou](https://www.engineering.columbia.edu/faculty-staff/directory/xunyu-zhou). His research lies at the intersection of **reinforcement learning (RL)**, **diffusion models for generative AI (GenAI)**, **stochastic control**, and **financial engineering**, with a focus on developing and analyzing **continuous-time RL algorithms** for decision making under uncertainty.

Huang earned his PhD in Industrial Engineering and Operations Research at Columbia University in 2024, where he was advised by Professor Xun Yu Zhou. He also holds an M.S. in Operations Research from Columbia University (2018) and a B.S. in Mathematics and Applied Mathematics from Zhejiang University (2017).

His work combines theoretical guarantees with empirical validation.

### Key Contributions:
- **Continuous-Time RL for Diffusion Sampling in GenAI**: Introduced **Adaptive Reparameterized Time (ART)** to learn **nonuniform timestep schedules** by controlling the sampling clock speed, and proposed **ART-RL**, a **continuous-time actor-critic** method with Gaussian policies that provably recovers the optimal ART schedule; empirically, it improves FID on CIFAR-10 across sampling budgets and transfers to AFHQv2, FFHQ, and ImageNet without retraining.

- **Continuous-Time RL for Portfolio Optimization**: Developed a **continuous-time actor-critic RL algorithm** for mean-variance (MV) portfolio optimization. This algorithm achieves a **sublinear regret bound** in terms of the Sharpe ratio, with strong empirical results using U.S. stock data from 2000 to 2019, demonstrating superior performance against 14 established strategies, particularly during bear markets.

- **Model-Free RL in Linear-Quadratic (LQ) Control**: Proposed **model-free reinforcement learning algorithms** for continuous-time LQ problems, addressing scenarios where volatilities depend on both state and control variables. Introduced two actor-critic approaches, one with deterministic exploration and another with data-driven exploration, that achieve **sublinear regret bounds**. These methods outperform recent model-based techniques in numerical experiments.

Yilie Huang’s work bridges the gap between theory and application, advancing decision-making strategies in uncertain environments. Explore his [Publications](https://yiliehuang.github.io/publications) and [CV](https://yiliehuang.github.io/files/CV_Yilie_Huang.pdf) for more details.

