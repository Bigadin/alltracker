FROM nvidia/cuda:12.8.0-runtime-ubuntu22.04

# Dépendances système minimales
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip ffmpeg libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Installer d'abord les dépendances hors torch*
COPY requirements.txt ./requirements.txt
RUN python3 -m pip install --upgrade pip && \
    sed -E '/^(torch|torchvision|torchaudio)(\b|==|>=|<=)/Id' requirements.txt > requirements.notorch.txt && \
    pip3 install --no-cache-dir -r requirements.notorch.txt

# Installer torch/torchvision/torchaudio depuis l'index CU128 demandé
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

# Copier le code
COPY . .

# Commande par défaut
CMD ["python3", "demo.py"]
