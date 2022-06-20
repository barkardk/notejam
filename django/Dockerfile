FROM python:2.7
EXPOSE 8000
COPY . /notejam
WORKDIR /notejam
RUN pip install -r requirements.txt
RUN cd notejam && ./manage.py syncdb --noinput && ./manage.py migrate --noinput

CMD [ "python", "/notejam/notejam/manage.py", "runserver", "0.0.0.0:8000" ]