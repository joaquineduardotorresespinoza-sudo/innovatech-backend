# Usamos una imagen muy ligera de Node.js
FROM node:18-alpine

# Definimos el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos primero solo los archivos de configuración de dependencias
# Esto ayuda a optimizar la caché de Docker
COPY package*.json ./

# Instalamos SOLAMENTE las dependencias necesarias para producción
RUN npm install --only=production

# Copiamos el resto del código del servidor (app.js, server.js, db.js, etc.)
COPY . .

# ==========================================
# REQUISITO DE LA PAUTA: USUARIO NO ROOT
# ==========================================
# Cambiamos los permisos de la carpeta para que el usuario 'node' (que ya viene
# en esta imagen) sea el dueño. Esto previene problemas de seguridad.
RUN chown -R node:node /app

# Cambiamos al usuario no privilegiado 'node'
USER node

# Exponemos el puerto que usa el backend por defecto
EXPOSE 3001

# Comando para iniciar el servidor
CMD ["node", "src/server.js"]
