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
    dendrite-component: {{ $component }}
spec:
  selector:
    matchLabels:
      app: {{ $.Chart.Name }}
      dendrite-component: {{ $component }}
  replicas: 1
  template:
    metadata:
      labels:
        app: {{ $.Chart.Name }}
        dendrite-component: {{ $component }}
    spec:
      volumes:
      - name: dendrite-conf-vol
        configMap:
          name: {{ $.Chart.Name }}-conf
      - name: dendrite-logs
        persistentVolumeClaim:
          claimName: {{ default "dendrite-logs-pvc" $.Values.persistence.logs.existingClaim | quote }}
      {{- if eq $component "mediaapi" }}
      - name: dendrite-media
        persistentVolumeClaim:
          claimName: {{ default "dendrite-media-pvc" $.Values.persistence.media.existingClaim | quote }}
      {{- end }}
      containers:
      - name: {{ $component }}
        {{- include "image.name" $.Values.image | nindent 8 }}
        args:
          - '--config'
          - '/etc/dendrite/dendrite.yaml'
          - {{ $component }}
        resources:
        {{- toYaml $.Values.resources | nindent 10 }}
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
          name: dendrite-conf-vol
        - mountPath: /var/log/dendrite/
          name: dendrite-logs
        {{- if eq $component "mediaapi" }}
        - mountPath: /data/media_store 
          name: dendrite-media      
        {{- end }}
{{ end }}
{{ end }}