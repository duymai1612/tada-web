FROM node:lts as dependencies
WORKDIR /tada
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM node:lts as builder
WORKDIR /tada
COPY . .
COPY --from=dependencies /tada/node_modules ./node_modules
RUN yarn build

FROM node:lts as runner
WORKDIR /tada
ENV NODE_ENV production
# If you are using a custom next.config.js file, uncomment this line.
# COPY --from=builder /tada/next.config.js ./
# COPY --from=builder /tada/public ./public
COPY --from=builder /tada/.next ./.next
COPY --from=builder /tada/node_modules ./node_modules
COPY --from=builder /tada/package.json ./package.json

EXPOSE 3000
CMD ["yarn", "start"]
