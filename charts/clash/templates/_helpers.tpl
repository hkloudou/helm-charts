{{/*
Expand the name of the chart.
*/}}
{{- define "clash.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "clash.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "clash.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "clash.labels" -}}
helm.sh/chart: {{ include "clash.chart" . }}
{{ include "clash.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "clash.selectorLabels" -}}
app.kubernetes.io/name: {{ include "clash.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "clash.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "clash.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}





{{- define "clash.volumes" -}}
- name: shared-data
  persistentVolumeClaim:
    claimName: {{ .Values.config.existingClaim | default (printf "%s-pvc" (include "clash.fullname" .)) }}
{{- if .Values.config.enable}}
- name: auto-config-files
  configMap:
    name: {{ printf "%s-config-files" (include "clash.fullname" .) }}
    defaultMode: 0777
{{- end -}}
{{- end -}}

{{- define "clash.volumeMounts" -}}
- name: shared-data
  mountPath: {{.Values.config.path}}
{{- if .Values.config.enable}}
- name: auto-config-files
  mountPath: /init/
{{- end -}}
{{- end -}}