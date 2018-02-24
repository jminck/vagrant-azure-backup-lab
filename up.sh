vagrant up control
vagrant up dc01 --no-destroy-on-error || vagrant reload  dc01 --provision
vagrant up
