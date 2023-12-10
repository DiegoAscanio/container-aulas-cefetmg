# How to Run

1. Build this image:

    ```bash
    docker build -t ascanio/sandbox-aulas .
    ```

2. Run this image (your linux user needs to be at docker group):
    ```bash
    docker run --privileged -it --rm -p 6080:6080 -v ~/sandbox-aulas:/sandbox-aulas ascanio/sandbox-aulas
    ```

3. Make ~/sandbox-aulas folder accessible to your user:
    ```bash
    sudo chmod -R 777 ~/sandbox-aulas
    ```

3. Open your browser and go to: http://localhost:6080/

4. Drop any needed files at ~/sandbox-aulas so you can access them from the docker container. Also, if you need to save any files inside the docker container, save it into the /sandbox-aulas folder otherwise any modifications will be wiped when you close your container.

At the present moment we only have arduino IDE installed. If you need any other software, please open an issue at.
