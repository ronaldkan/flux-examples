generate-latest-flux-system:
	flux install --export > ${CLUSTER_ENV}/flux-system/gotk-components.yaml
