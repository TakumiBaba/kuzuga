applescript = require "applescript"
exec = require("child_process").exec
cronJob = require('cron').CronJob

crontime = "*/1 * * * *";

as = """
if application "Twitter" is running
  true
else
  false
end if
"""

job = new cronJob
  cronTime: crontime
  onTick: ->
    applescript.execString as, (err, rtn)=>
      throw err if err
      if rtn is "true"
        command = "linda-rocketio write"
        tuple = "-tuple '[\"twitter\", \"@takumibaba がついったーを開いています。罵ってあげてください。\"]'"
        base = "-base http://linda.masuilab.org"
        space = "-space takumibaba"
        sh = "#{command} #{tuple} #{base} #{space}"
        exec sh, (err, stdout, stderr)=>
          throw err if err
          throw stderr if stderr
          console.log stdout
      else
        console.log 'false'
  onComplete: ->
    console.log 'complete'
  start: false
  timeZone: "Japan/Tokyo"

job.start();