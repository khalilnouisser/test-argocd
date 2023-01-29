{{/*
Expand the name of the chart.
*/}}
{{- define "helm-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 52 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helm-app.fullname" -}}
{{- .Release.Name | trunc 52 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "helm-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 52 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helm-app.labels" -}}
helm.sh/chart: {{ include "helm-app.chart" . }}
{{ include "helm-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helm-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Env variables
*/}}
{{- define "helm-app.env_list"}}
{{- $fullName := include "helm-app.fullname" . -}}
{{- range $key, $val := .Values.env.secret }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $fullName }}
      key: {{ $key }}
{{- end}}
{{- range $key, $val := .Values.env.config }}
- name: {{ $key }}
  valueFrom:
    configMapKeyRef:
      name: {{ $fullName }}
      key: {{ $key }}
{{- end}}
{{- end }}
