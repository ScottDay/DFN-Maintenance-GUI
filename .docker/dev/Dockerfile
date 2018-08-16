# https://stackoverflow.com/questions/33322103/multiple-froms-what-it-means#33322374

## DFN-Maintenance-GUI-Frontend.
## ====================
FROM node:10 as node

COPY DFN-Maintenance-GUI-Frontend/* DFN-Maintenance-GUI-Frontend/
WORKDIR DFN-Maintenance-GUI-Frontend
RUN npm install; npm run build
WORKDIR /
RUN cp DFN-Maintenance-GUI-Frontend /; rm -rf DFN-Maintenance-GUI-Frontend