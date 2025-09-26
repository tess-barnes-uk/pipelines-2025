# Tips for node related things

## config
- what on earth is an [.nvmrc](https://thawinwats.medium.com/change-project-change-node-version-let-nvmrc-help-you-630b34dafd09) file for?

## package management
- what's all the fuss about PNPM rather than npm, and how can we do things safely?
  - about [pnpm](https://pnpm.io/motivation), and why you should use a [frozen lockfile](https://pnpm.io/cli/install#--frozen-lockfile)
  - pnpm in [github actions](https://github.com/pnpm/action-setup?tab=readme-ov-file#use-cache-to-reduce-installation-time)
  - pnpm will refuse to run post install scripts unless explicitly allowed in a workspace config file

## patching and vulnerability managment
- checking for [outdated](https://pnpm.io/cli/outdated) packages
- [docs](https://pnpm.io/cli/audit) about running package audit checks

## linting
- more about [prettier](https://prettier.io/)

## trouble shooting
- `node-gyp` compilation errors? [omit optional dependencies](https://pnpm.io/cli/install#tldr) when running pnpm install 
