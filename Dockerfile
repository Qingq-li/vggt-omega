# syntax=docker/dockerfile:1.7

ARG BASE_IMAGE=vggt:cuda13.2
FROM ${BASE_IMAGE} AS app

ENV PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    VIRTUAL_ENV=/opt/venv \
    GRADIO_SERVER_NAME=0.0.0.0 \
    GRADIO_SERVER_PORT=7860 \
    GRADIO_SHARE=false

ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

WORKDIR /workspace
RUN rm -rf /workspace/vggt && mkdir -p /workspace/vggt
WORKDIR /workspace/vggt

COPY requirements.txt requirements_demo.txt pyproject.toml ./
RUN grep -vE '^(torch|torchvision)([<>=~! ]|$)' requirements.txt > /tmp/requirements-notorch.txt \
    && python3 -m pip install -r /tmp/requirements-notorch.txt \
    && python3 -m pip install -r requirements_demo.txt \
    && rm /tmp/requirements-notorch.txt

COPY . .
RUN python3 -m pip install -e .

RUN mkdir -p /checkpoints /workspace/vggt/demo_outputs

EXPOSE 7860

CMD ["python3", "demo_gradio.py", "--checkpoint", "/checkpoints/model.pt", "--image-resolution", "512", "--server-name", "0.0.0.0", "--server-port", "7860"]
