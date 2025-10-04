import json, subprocess

def __direnv():
    try:
        r = subprocess.check_output(["direnv", "export", "json"], text=True)
        if not r.strip():
            return
        lines = json.loads(r)
        with __xonsh__.env.swap(UPDATE_OS_ENVIRON=True):
            for k, v in lines.items():
                if v is None:
                    __xonsh__.env.pop(k, None)
                else:
                    __xonsh__.env[k] = v
    except Exception as e:
        print("direnv failed:", e)

@events.on_post_init
def _init(**kw):
    __direnv()

@events.on_chdir
def _cd(olddir, newdir, **kw):
    __direnv()
