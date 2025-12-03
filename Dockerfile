FROM ghcr.io/infitx-org/ml-e2e-test-runner:v0.0.10

# Define variables for TTK test cases repository
ARG TEST_CASES_REPO_TAG=v20.1.0
ARG TEST_CASES_SOURCE_FOLDER=collections/hub/golden_path/e2e_tests

WORKDIR /opt/app

COPY ttk-test-collection /opt/app/ttk-test-collection

# Install git as root
USER root

RUN apk add --no-cache git

# Clone mojaloop testing-toolkit-test-cases repo
RUN git clone --depth 1 \
               --branch ${TEST_CASES_REPO_TAG} \
               https://github.com/mojaloop/testing-toolkit-test-cases.git \
               /tmp/ttk-test-cases

# Copy files to destination
RUN mkdir -p /opt/app/ttk-test-collection/multi-scheme-tests && \
    cp -r /tmp/ttk-test-cases/${TEST_CASES_SOURCE_FOLDER}/* \
          /opt/app/ttk-test-collection/multi-scheme-tests/

# Cleanup temporary files
RUN rm -rf /tmp/ttk-test-cases

# Switch back to the user
USER e2e-user

CMD ["npm", "run", "start"]
