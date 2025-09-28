ARG NODE_VERSION=22

FROM node:${NODE_VERSION}-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

FROM base AS prod

WORKDIR /app
COPY pnpm-workspace.yaml /app
COPY package.json /app
COPY pnpm-lock.yaml /app
RUN pnpm install --prod --frozen-lockfile --no-optional

COPY . /app

FROM base
WORKDIR /app
COPY --from=prod /app/node_modules /app/node_modules
COPY --from=prod /app/package.json /app/package.json
COPY --from=prod /app/src /app/src

EXPOSE 3000

CMD [ "pnpm", "start" ]
