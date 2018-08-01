# https://stackoverflow.com/questions/33322103/multiple-froms-what-it-means#33322374

# NodeJS Compilation Build.
# ====================
FROM node:10 as node

WORKDIR /build

## DFN-Maintenance-GUI-Frontend.
## ====================

RUN cd DFN-Maintenance-GUI-Frontend; npm install --only=production; npm run build
COPY DFN-Maintenance-GUI-Frontend/dist/ /build

## DFN-Maintenance-GUI-Config. 
## ====================

### TODO[Scott]: Flesh out config repo and setup build script for specific regions config files https://askubuntu.com/a/333641.


# Python Build (what the docker image will use, nodejs is removed).
# ====================
FROM python:3.6.1

WORKDIR /
EXPOSE 5000
CMD [ "python", "./main.py" ] 

## Copy output from node image build to python image.
COPY --from=node /build /

## DFN-Maintenance-GUI-Backend.
## ====================

COPY DFN-Maintenance-GUI-Backend/requirements/prod.txt /
RUN pip install --no-cache-dir -r /prod.txt