{{- define "validate.config" }}
{{- if not .Values.configuration.signing_key.create -}}
{{-  fail "You must create a signing key for configuration.signing_key. (see https://github.com/matrix-org/dendrite/blob/master/docs/INSTALL.md#server-key-generation)" -}}
{{- end -}}
{{- if not .Values.configuration.database.host -}}
{{-  fail "Database server must be set." -}}
{{- end -}}
{{- if not .Values.configuration.database.user -}}
{{-  fail "Database user must be set." -}}
{{- end -}}
{{- if not .Values.configuration.database.password -}}
{{-  fail "Database password must be set." -}}
{{- end -}}
{{- if and (eq (len .Values.configuration.jetstream.addresses) 0) .Values.polylith -}}
{{-  fail "When using polylith, a NATS JetStream address is required." -}}
{{- end -}}
{{- end -}}

{{- define "image.name" -}}
image: {{ .name }}
imagePullPolicy: {{ .pullPolicy }}
{{- end -}}