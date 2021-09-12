import asyncio
import uvloop
import ib_insync as ibi


class App:

    async def run(self):
        self.ib = ibi.IB()
        with await self.ib.connectAsync(host="192.168.0.175",port=7497):
            if self.ib.isConnected():
                print(await self.ib.accountSummaryAsync(self.ib.accountValues()[0].account))

    def stop(self):
        self.ib.disconnect()


app = App()
try:
    uvloop.install()
    asyncio.run(app.run())
except (KeyboardInterrupt, SystemExit):
    app.stop()