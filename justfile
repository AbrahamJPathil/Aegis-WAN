set shell := ["bash", "-c"]

root := invocation_directory()

# Start everything in parallel across gnome-terminal tabs
up:
    @gnome-terminal \
        --tab --title="router" --working-directory="{{root}}" -- bash -c "just router_up; exec bash" \
        --tab --title="gps" --working-directory="{{root}}" -- bash -c "just gps_up; exec bash" \
        --tab --title="frontend" --working-directory="{{root}}" -- bash -c "just frontend_up; exec bash" \
        --tab --title="predictor" --working-directory="{{root}}" -- bash -c "just predictor_up; exec bash" \
        --tab --title="router-exp" --working-directory="{{root}}" -- bash -c "just router_exporter; exec bash" \
        --tab --title="pred-exp" --working-directory="{{root}}" -- bash -c "just predictor_exporter; exec bash" \
        --tab --title="docker" --working-directory="{{root}}" -- bash -c "just docker_up; exec bash"

[working-directory: "router/apiserver"]
router_up:
    uv run main.py

[working-directory: "router/apiserver"]
router_exporter:
    uv run exporter.py

[working-directory: "vessel-gps"]
gps_up:
    uv run uvicorn main:app --port=8001

[working-directory: "frontend"]
frontend_up:
    npm run dev

[working-directory: "predictor"]
predictor_up:
    uv run app.py

[working-directory: "predictor"]
predictor_exporter:
    uv run aegis_exporter.py

[working-directory: "prometheus"]
docker_up:
    docker compose up

[working-directory: "prometheus"]
docker_down:
    docker compose down
