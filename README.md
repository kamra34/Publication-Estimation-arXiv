# Exploring Positive Noise in Estimation Theory

This repository contains the implementation of the research paper "Exploring positive noise in estimation theory", which investigates the estimation of a deterministic quantity observed in non-Gaussian additive noise via order statistics approach. The study focuses on cases where measurement noises have positive supports or follow a mixture of normal and uniform distribution. This problem is particularly relevant in cellular positioning systems, where the wireless signal is prone to multiple sources of noises with generally positive support.

## Abstract
Estimation of a deterministic quantity observed in non-Gaussian additive noise is explored via order statistics approach. More specifically, we study the estimation problem when measurement noises either have positive supports or follow a mixture of normal and uniform distribution. This is a problem of great interest specially in cellular positioning systems where the wireless signal is prone to multiple sources of noises which generally have a positive support. Multiple noise distributions are investigated and, if possible, minimum variance unbiased (MVU) estimators are derived. In case of uniform, exponential and Rayleigh noise distributions, unbiased estimators without any knowledge of the hyper parameters of the noise distributions are also given. For each noise distribution, the proposed order statistic-based estimator’s performance, in terms of variance, is compared to the best linear unbiased estimator (BLUE), as a function of sample size, in a simulation study. The results show that, even for unknown hyper parameter scenarios, the proposed estimators have less variance compared to BLUE.

## Conclusion
In this work, the location estimation problem was studied in which an unknown parameter was estimated from observations under additive noise. Multiple noise distributions were considered and, in some cases, MVU estimators were proposed. In other cases an unbiased estimator based on minimum order statistic was derived. Furthermore, if applicable, MVU and minimum order statistic estimators without any knowledge of the hyper parameters of the underlying noise distributions were provided. The results of all the estimators were compared with BLUE in terms of variance for various measurement sample sizes. The results indicate better performance of the proposed estimators compared to BLUE, even for the case of unknown hyper parameters. Additionally, the location estimation problem under mixture of normal and uniform noise distribution was studied and the numerical variance and bias of the proposed estimator were evaluated.

## Code Structure

The code is implemented in MATLAB and Mathematica and is organized as follows:

- `matlab/`: Contains MATLAB implementation of the proposed estimators and simulation studies.
- `mathematica/`: Contains Mathematica implementation of the derivations, statistics, and formulas used in the paper.

## Dependencies

To run the code, you'll need the following software installed:

- MATLAB (tested on version R2021a)
- Mathematica (tested on version 12.2)

## Usage

1. Clone the repository.
2. Navigate to the `matlab/` or `mathematica/` folder, depending on your choice of implementation.
3. Run the corresponding scripts or notebooks to reproduce the results presented in the paper.

## Citation

If you find this work useful, please consider citing the original paper:

@article{Radnosrati_2020,
	doi = {10.1109/tsp.2020.2999204},
  
	url = {https://doi.org/10.1109%2Ftsp.2020.2999204},
  
	year = 2020,
	publisher = {Institute of Electrical and Electronics Engineers ({IEEE})},
  
	volume = {68},
  
	pages = {3590--3602},
  
	author = {Kamiar Radnosrati and Gustaf Hendeby and Fredrik Gustafsson},
  
	title = {Exploring Positive Noise in Estimation Theory},
  
	journal = {{IEEE} Transactions on Signal Processing}
}


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
