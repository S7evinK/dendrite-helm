{{ define "service.polylith" }}
{{ range $component, $value := $.Values.components }}
---
apiVersion: v1
kind: Service
metadata:
  namespace: {{ $.Release.Namespace }}
  name: {{ $component }}
  labels:
    app: {{ $.Chart.Name }}
    dendrite-component: {{ $component }}
spec:
  selector:
    app: {{ $.Chart.Name }}
    dendrite-component: {{ $component }}
  ports:
    - name: {{ $component }}-int
      protocol: TCP
      port: {{ $value.listen_int }}
      targetPort: {{ $value.listen_int }}
    {{- if $value.listen_ext }}
    - name: {{ $component }}-ext
      protocol: TCP
      port: {{ $value.listen_ext }}
      targetPort: {{ $value.listen_ext }}
    {{ end }}
{{ end }}
{{ end }}