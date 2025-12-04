FROM ghcr.io/infitx-org/ml-e2e-test-runner:v0.0.10

# Define variables for TTK test cases repository
ARG TEST_CASES_REPO_TAG=v20.1.0
ARG TEST_CASES_REQUIRED_PATHS="\
    collections/hub/golden_path/e2e_tests/p2p.json \
    collections/hub/golden_path/e2e_tests/quotes.json \
    collections/hub/golden_path/e2e_tests/transfers.json"

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

# Copy only specified files and folders to destination
RUN mkdir -p /opt/app/ttk-test-collection/multi-scheme-tests && \
    for path in ${TEST_CASES_REQUIRED_PATHS}; do \
        cp -r /tmp/ttk-test-cases/$path /opt/app/ttk-test-collection/multi-scheme-tests/; \
    done

# Cleanup temporary files
RUN rm -rf /tmp/ttk-test-cases

# Switch back to the user
USER e2e-user

CMD ["npm", "run", "start"]
