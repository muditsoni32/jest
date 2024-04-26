FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Build the project (if applicable)
# RUN npm run build  # Replace with your build command if needed

FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY --from=builder /app/node_modules ./node_modules

# Include jest-junit reporter
COPY jest.config.js ./  # Assuming your Jest config is named jest.config.js
COPY jest-junit.js ./    # Assuming jest-junit.js is your custom reporter file (optional)

CMD ["npm", "test", "--coverage", "--reporters=jest-junit"]

# Adjust the command above based on your testing needs.
# You can also use a custom script to run tests.
