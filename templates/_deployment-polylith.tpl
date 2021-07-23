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
      - name: dendrite-logs-nfs
        persistentVolumeClaim:
          claimName: dendrite-logs-pvc
      {{- if eq $component "mediaapi" }}
      - name: dendrite-media-nfs
        persistentVolumeClaim:
          claimName: dendrite-media-pvc
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
        volumeMounts:
        - mountPath: /etc/dendrite/
          name: dendrite-conf-vol
        - mountPath: /var/log/dendrite/
          name: dendrite-logs-nfs
        {{- if eq $component "mediaapi" }}
        - mountPath: /data/media_store 
          name: dendrite-media-nfs          
        {{- end }}
{{ end }}
{{ end }}