IMAGE ?= vggt-omega:docker
CHECKPOINT ?= /home/prefor/Downloads/vggt_omega_1b_512.pt
PORT ?= 7860
OUT_DIR ?= $(CURDIR)/demo_outputs

.PHONY: run build shell

run:
	mkdir -p "$(OUT_DIR)"
	docker run --rm --gpus all \
		-p $(PORT):7860 \
		-v "$(CHECKPOINT):/checkpoints/model.pt:ro" \
		-v "$(OUT_DIR):/workspace/vggt/demo_outputs" \
		$(IMAGE)

build:
	docker build -t $(IMAGE) .

shell:
	docker run --rm --gpus all -it \
		-v "$(CURDIR):/workspace/vggt" \
		$(IMAGE) bash
