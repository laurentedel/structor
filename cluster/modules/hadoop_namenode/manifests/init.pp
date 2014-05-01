class hadoop_namenode {
  require hadoop_base

  $PATH="/bin:/usr/bin"

  if $security == "true" {
    require kerberos_http
    file { "/etc/security/hadoop/nn.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/nn.keytab",
      owner => hdfs,
      group => hadoop,
      mode => '400',
    }
    ->
    exec { "kinit -k -t /etc/security/hadoop/nn.keytab nn/${hostname}.${domain}":
      path => $PATH,
      user => hdfs,
    }
    ->
    Package['hadoop-namenode']
  }

  package { "hadoop-namenode" :
    ensure => installed,
  }
  ->
  exec {"namenode-format":
    command => "hadoop namenode -format",
    path => "$PATH",
    creates => "${data_dir}/hdfs/nn",
    user => "hdfs",
    require => Package['hadoop-namenode'],
  }
  ->
  service {"hadoop-namenode":
    ensure => running,
    enable => true,
  }
  ->
  exec {"mapred-home-mkdir":
    command => "hadoop fs -mkdir /user/mapred",
    unless => "hadoop fs -test -e /user/mapred",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"mapred-home-chown":
    command => "hadoop fs -chown mapred:mapred /user/mapred",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"vagrant-home-mkdir":
    command => "hadoop fs -mkdir /user/vagrant",
    unless => "hadoop fs -test -e /user/vagrant",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"vagrant-home-chown":
    command => "hadoop fs -chown vagrant:vagrant /user/vagrant",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"hive-warehouse":
    command => "hadoop fs -mkdir /apps/hive/warehouse",
    unless => "hadoop fs -test -e /apps/hive/warehouse",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"hive-warehouse-chmod":
    command => "hadoop fs -chmod 777 /apps/hive/warehouse",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"hdfs-tmp":
    command => "hadoop fs -mkdir /tmp",
    unless => "hadoop fs -test -e /tmp",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"hdfs-tmp-chmod":
    command => "hadoop fs -chmod 777 /tmp",
    path => "$PATH",
    user => "hdfs",
  }
}