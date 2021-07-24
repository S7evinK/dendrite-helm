{{- define "validate.config" }}
{{- if not .Values.configuration.matrix_key -}}
{{-  fail "You must create an encryption key for configuration.matrix_key. (see https://github.com/matrix-org/dendrite/blob/master/docs/INSTALL.md#server-key-generation)" -}}
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
{{- end -}}

{{- define "image.name" -}}
image: {{ .name }}
imagePullPolicy: {{ .pullPolicy }}
{{- end -}}