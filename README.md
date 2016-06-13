provide a redis cluster to rancher 

confd=> met à jour le script  start.sh pour y mettre :
l'ip du leader, et l'ip du container
si ip du container différent du leader => slaveOf leader
sinon, pas de slaveOf

pour sentinel => sentinel de l'ip leader
