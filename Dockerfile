# OPAM for alpine-3.3 with local switch of OCaml 4.01.0
# Autogenerated by OCaml-Dockerfile scripts
FROM ocaml/ocaml:alpine-3.3
LABEL distro_style="apk" distro="alpine" distro_long="alpine-3.3" arch="x86_64" ocaml_version="4.01.0" opam_version="1.2" operatingsystem="linux"
RUN apk update && apk upgrade && \
  apk add rsync xz opam && \
  curl -o /usr/bin/aspcud 'https://raw.githubusercontent.com/avsm/opam-solver-proxy/38133c7f82bae3f1aa9f7505901f26d9fb0ed1ee/aspcud.docker' && \
  chmod 755 /usr/bin/aspcud && \
  adduser -S opam && \
  echo 'opam ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/opam && \
  chmod 440 /etc/sudoers.d/opam && \
  chown root:root /etc/sudoers.d/opam && \
  sed -i.bak 's/^Defaults.*requiretty//g' /etc/sudoers
USER opam
WORKDIR /home/opam
RUN mkdir .ssh && \
  chmod 700 .ssh && \
  git config --global user.email "docker@example.com" && \
  git config --global user.name "Docker CI" && \
  sudo -u opam sh -c "git clone -b master git://github.com/ocaml/opam-repository" && \
  sudo -u opam sh -c "opam init -a -y --comp 4.01.0 /home/opam/opam-repository" && \
  sudo -u opam sh -c "opam install -y depext travis-opam"
ENTRYPOINT [ "opam", "config", "exec", "--" ]
CMD [ "sh" ]