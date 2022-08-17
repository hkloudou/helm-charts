test-clash:
	# helm install clash --namespace clash ../charts/clash/
	helm template clash --namespace clash \
		--set-file config.value=$(HOME)/.config/clash/config.yaml \
		--set config.enable=true \
		--set config.url="xx" \
		--debug \
		./charts/clash/ > tests/results/clash.yaml