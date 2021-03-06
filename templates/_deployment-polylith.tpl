{{ define "deployment.polylith" }}
{{ range $component, $value := .Values.components }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: {{ $.Release.Namespace }}
  name: {{ $component }}
  labels:
    app: {{ $.Chart.Name }}
    component: {{ $component }}
spec:
  selector:
    matchLabels:
      app: {{ $.Chart.Name }}
      component: {{ $component }}
  replicas: 1
  template:
    metadata:
      labels:
        app: {{ $.Chart.Name }}
        component: {{ $component }}
    spec:
      volumes:
      - name: {{ $.Chart.Name }}-conf-vol
        secret:
          secretName: {{ $.Chart.Name }}-conf
      - name: dendrite-logs
        persistentVolumeClaim:
          claimName: {{ default "dendrite-logs-pvc" $.Values.persistence.logs.existingClaim | quote }}
      - name: {{ $.Chart.Name }}-signing-key
        secret:
          secretName: {{ default "dendrite-signing-key" $.Values.configuration.signing_key.existingSecret | quote }}
      {{- if eq $component "mediaapi" }}
      - name: dendrite-media
        persistentVolumeClaim:
          claimName: {{ default "dendrite-media-pvc" $.Values.persistence.media.existingClaim | quote }}
      {{- end }}
      {{- if (gt (len ($.Files.Glob "appservices/*")) 0) }}
      - name: {{ $.Chart.Name }}-appservices
        secret:
          secretName: {{ $.Chart.Name }}-appservices-conf
      {{- end }}
      containers:
      - name: {{ $component }}
        {{- include "image.name" $.Values.image | nindent 8 }}
        args:
          - '--config'
          - '/etc/dendrite/dendrite.yaml'
          - {{ $component }}
        resources:
        {{- if $value.resources }}
        {{- toYaml $value.resources | nindent 10 -}}
        {{ else }}
        {{- toYaml $.Values.resources | nindent 10 -}}
        {{- end -}}
        {{-  if $.Values.configuration.profiling.enabled }}
        env:
          - name: PPROFLISTEN
            value: "localhost:{{- $.Values.configuration.profiling.port -}}"
        {{- end }}
        startupProbe:
          tcpSocket:
            port: {{ $value.listen_int }}
          periodSeconds: 10
          failureThreshold: 12
        readinessProbe:
          tcpSocket:
            port: {{ $value.listen_int }}
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          tcpSocket:
            port: {{ $value.listen_int }}
          initialDelaySeconds: 5
          periodSeconds: 20
        volumeMounts:
        - mountPath: /etc/dendrite/
          name: {{ $.Chart.Name }}-conf-vol
        - mountPath: /etc/dendrite/secrets/
          name: {{ $.Chart.Name }}-signing-key
        - mountPath: /var/log/dendrite/
          name: dendrite-logs
        {{- if eq $component "mediaapi" }}
        - mountPath: /data/media_store 
          name: dendrite-media      
        {{- end }}
        {{- if (gt (len ($.Files.Glob "appservices/*")) 0) }}
        - mountPath: /etc/dendrite/appservices
          name: {{ $.Chart.Name }}-appservices
          readOnly: true
        {{ end }}
{{ end }}
{{ end }}
