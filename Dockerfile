FROM python:3.7.5-slim-buster

# We need to set this so that
# we can install odbc drivers
# without any hassle. Because,
# the drivers prompt to install
# the package
ENV ACCEPT_EULA=Y

# We update the packages and then install packages that will
# give us support for HTTPS and SSL certificates
RUN apt-get update && apt-get install -y --no-install-recommends openssh-server

# We copy the requirements to the code directory,
# so that we can install the packages
COPY ./requirements.txt /code/requirements.txt

# We install the requirements, we need to
# we the directory here correctly, otherwise,
# requirements.txt will not be found
WORKDIR /code/
RUN echo "Python version $(python --version)"
RUN pip install -r requirements.txt

# We copy all our files to the code directory
COPY . /code/

# We copy ssh file
COPY sshd_config /etc/ssh/
RUN echo "root:Docker!" | chpasswd

# We expose the port that we are going to be using in our CMD
EXPOSE 8000 2222

# We give the container the main command to run
CMD mkdir /var/run/sshd && chmod 0755 /var/run/sshd && /usr/sbin/sshd ; gunicorn sample:app
