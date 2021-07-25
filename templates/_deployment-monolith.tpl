{{ define "deployment.monolith" }}
{{ $component := "monolith" }}
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
      - name: dendrite-media
        persistentVolumeClaim:
          claimName: {{ default "dendrite-media-pvc" $.Values.persistence.media.existingClaim | quote }}
      containers:
      - name: {{ $component }}
        {{- include "image.name" $.Values.image | nindent 8 }}
        args:
          - '--config'
          - '/etc/dendrite/dendrite.yaml'
        resources:
        {{- toYaml $.Values.resources | nindent 10 }}
        volumeMounts:
        - mountPath: /etc/dendrite/
          name: dendrite-conf-vol
        - mountPath: /var/log/dendrite/
          name: dendrite-logs
        - mountPath: /data/media_store
          name: dendrite-media
{{ end }}