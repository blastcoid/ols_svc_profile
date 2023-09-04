# Gunakan image Python Alpine sebagai base image
FROM python:alpine3.18

# Atur working directory di dalam container
WORKDIR /code

# Salin requirements.txt ke working directory
COPY ./requirements.txt /code/

# Tambahkan dependensi tambahan jika diperlukan
RUN apk --no-cache add build-base gcc musl-dev python3-dev

# Install semua dependensi yang ada di requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Salin semua kode aplikasi ke working directory
COPY . /code/

# Tambah user non-root untuk menjalankan aplikasi (lebih aman)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Expose port 8000
EXPOSE 8000

# Jalankan aplikasi
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
