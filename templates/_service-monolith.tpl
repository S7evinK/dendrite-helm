{{ define "service.monolith" }}
{{ $component := "monolith" }}
---
apiVersion: v1
kind: Service
metadata:
  namespace: {{ $.Release.Namespace }}
  name: {{ $component }}
  labels:
    app: {{ $.Chart.Name }}
    component: {{ $component }}
spec:
  selector:
    app: {{ $.Chart.Name }}
    component: {{ $component }}
  ports:
    - name: {{ $component }}-http
      protocol: TCP
      port: 8008
      targetPort: 8008
{{ end }}