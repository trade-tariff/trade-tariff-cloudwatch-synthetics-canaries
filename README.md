# trade-tariff-cloudwatch-synthetics-canaries

AWS CloudWatch Synthetics Canaries for the Online Trade Tariff (OTT).

## Prerequisites

- [`node`](https://nodejs.org/en) (Canaries run under node 18.x, the LTS)
- [`yarn`](https://yarnpkg.com/getting-started/install) (this repository uses
modern yarn, 'berry').

## Making changes

- To add more synthetics, create new JavaScript canaries. You can follow the
example in `index.js`, or follow the [AWS documentation][0].

- Terraform changes will be required, to add the new canary.

- Install and run the [`pre-commit`](https://pre-commit.com/) hooks when making
changes. These keep the Terraform documentation up to date, prevent linting
errors, and ensure your changes conform to the repository standards.

- Open a Pull Request with your changes. This will deploy the feature over the
development environment to proof that `terraform apply` runs without failure.

- Merges into `main` will deploy the changes into the staging environment, with
a manual approval step required for production.

## License

[MIT License](LICENSE)

[0]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries_WritingCanary_Nodejs.html
