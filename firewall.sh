#!/bin/sh
case "$1" in
  start)
  
	# CONFIGURE AQUI
	
	MEUIP="SEU_IP_AQUI"
	IPSEC="SEU_IP_AQUI"
	IPDOPAINEL="127.0.0.1"
	SERVIDORIP="IP_DO_SERVIDOR"
	
	# Fluindo Todas as Regras
	iptables -F
	iptables -X

	# Politicas Padroes
	iptables -P INPUT DROP
	iptables -P OUTPUT ACCEPT
	iptables -P FORWARD DROP

	# Ativação de trafego e loopback
	iptables -A INPUT -i lo -j ACCEPT
	# iptables -A OUTPUT -o lo -j ACCEPT				
		
		iptables -A INPUT -p icmp --icmp-type 8 -s 0/0 -d $SERVIDORIP -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
		iptables -A OUTPUT -p icmp --icmp-type 0 -s $SERVIDORIP -d 0/0 -m state --state ESTABLISHED,RELATED -j ACCEPT
	


	
	# PORTA SSH
	iptables -A INPUT -s $MEUIP -p tcp --dport 22 -j ACCEPT
	iptables -A INPUT -s $IPSEC -p tcp --dport 22 -j ACCEPT
      
	# PORTA GLINK	
	iptables -A INPUT -s 0/0 -p tcp --dport 29000 -j ACCEPT	
	
		
	# PORTA APACHE
	iptables -A INPUT -s $IPDOPAINEL -p tcp --dport 80 -j ACCEPT
	iptables -A INPUT -s $MEUIP -p tcp --dport 80 -j ACCEPT
	iptables -A INPUT -s $IPSEC -p tcp --dport 80 -j ACCEPT

	# PORTA MYSQL
	iptables -A INPUT -s $IPDOPAINEL -p tcp --dport 3306 -j ACCEPT
		
	# PORTA PWADMIN OU IWEB
	iptables -A INPUT -s $MEUIP -p tcp --dport 8080 -j ACCEPT
	iptables -A INPUT -s $IPSEC -p tcp --dport 8080 -j ACCEPT



	# LIBERANDO ESTABELECIMENTOS PARA ESSA MAQUINA
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    ;;
  stop)
	# Fluindo todas as regras
	# !! fluir pode travar alguns processos > Sistema Travou , Desligando!!!
	#iptables -F
	#iptables -X
    ;;
  *)
    echo "Use o comando: ./firewall.sh {start|stop}";
    exit 1;
    ;;
esac

exit 0
