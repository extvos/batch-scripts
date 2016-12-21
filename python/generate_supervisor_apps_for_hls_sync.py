# -*- coding: utf-8 -*-
PROGRAM_TEMPLATE = '''[program:%(name)s]
command=/export/app/hls-sync-v0.9.16 -V INFO -PZ Asia/Shanghai  -S -CF -RM -SO %(sync_root)s -RC -RO %(record_root)s -RI -ST -TD 5 -H -LS unix://%(record_root)s/hls-sync.sock http://10.255.167.3:6460/%(uri)s http://10.255.167.5:6460/%(uri)s
directory=%(record_root)s
autostart=true
redirect_stderr=true
stdout_logfile=%(record_root)s/hls-sync.log
stdout_logfile_maxbytes=10MB
stdout_logfile_backups=10
'''

if __name__ == '__main__':
    import os.path
    import sys
    import urlparse
    if len(sys.argv) > 1:
        CHANNEL_URLS = sys.argv[1:]
    else:
        CHANNEL_URLS = []

    for x in CHANNEL_URLS:
        x = x.strip()
        scheme, netloc, path, query, fragment = urlparse.urlsplit(x)
        # print 'scheme:', scheme
        # print 'netloc:', netloc
        # print 'path:', path
        # print 'query:', query
        # print 'fragment:', fragment
        path = path.lstrip('/')
        basepath = os.path.splitext(path)[0]
        print PROGRAM_TEMPLATE % dict(name=basepath, uri=path, sync_root='/dev/shm/luzhi/'+basepath, record_root='/export/data1/luzhi/'+basepath)