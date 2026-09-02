# Base image
FROM node:26-alpine

# Create app directory
WORKDIR /usr/src/app

# Install pnpm (corepack is no longer bundled with Node.js 26)
RUN npm install -g pnpm@11

# A wildcard is used to ensure both package.json AND pnpm-lock.yaml are copied
# pnpm-workspace.yaml carries the pnpm settings (see "allowBuilds" there)
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

# Install app dependencies
RUN pnpm install --frozen-lockfile

# Bundle app source
COPY . .

# Define variables (declared here so the layers above are shared by every service)
ARG APP_NAME
# Persist the build arg as an environment variable so it is also available at runtime (CMD)
ENV APP_NAME=${APP_NAME}

# Creates a "dist" folder with the production build
RUN pnpm run build ${APP_NAME}

# Start the server using the production build
# The shell form is required, otherwise ${APP_NAME} is not expanded
CMD [ "sh", "-c", "node dist/apps/${APP_NAME}/main.js" ]
