Si jamais vous avez ce message d'erreur :

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @ WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! @ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY! Someone could be eavesdropping on you right now (man-in-the-middle attack)! It is also possible that the RSA host key has just been changed. The fingerprint for the RSA key sent by the remote host is ab:cd:ef:gh Please contact your system administrator. Add correct host key in /home/user/.ssh/known_hosts to get rid of this message. Offending key in /home/user/.ssh/known_hosts:1 RSA host key for user.server has changed and you have requested strict checking. Host key verification failed.
```

je vous invite à regarder ce post pour mieux comprendre le problème : https://stackoverflow.com/questions/4161548/how-to-establish-ssh-key-pair-when-host-key-verification-failed