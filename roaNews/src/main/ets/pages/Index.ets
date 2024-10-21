import { http } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit';

interface News {
  title: string
  href: string
  time: string | undefined
}

let localStorage: LocalStorage = new LocalStorage()

localStorage.setOrCreate<News[]>('newsList', [])
localStorage.setOrCreate<boolean>('isLoading', true)

let newsList: SubscribedAbstractProperty<News[]> = localStorage.link('newsList')
let isLoading: SubscribedAbstractProperty<boolean> = localStorage.link('isLoading')

let httpRequest = http.createHttp()
httpRequest.on('headersReceive', (header) => {
  console.info('header: ' + JSON.stringify(header));
});

httpRequest.request(
  '',
  {
    method: http.RequestMethod.GET,
  },
  (err: BusinessError, data: http.HttpResponse) => {
    if (!err) {
      try {
        let list: News[] = data.result as News[]
        newsList.set([...list])
      } catch (e) {
        console.error(
          'error on decode news list response: ' + JSON.stringify(err)
            + '\ndata received is: ' + data.result
        )
      }
    } else {
      console.error('error on get news list: ' + JSON.stringify(err))
      httpRequest.off('headersReceive')
    }

    httpRequest.destroy()
  },
)

@Entry({
  storage: localStorage
})
@Component
struct Index {
  @LocalStorageProp('newsList') newsList: News[] = []
  @LocalStorageProp('isLoading') isLoading: boolean = true

  build() {
    Column({
      space: 16
    }) {
      if (isLoading) {
        Text('Loading...')
      }else if (newsList.get().length === 0) {
        Text('List is empty!')
      } else {
        List({}) {
          ForEach(this.newsList, (news: News) => {
            ListItem() {
              Column() {
                Text(news.title)
                  .fontSize(48)
                Text(news.href)
                  .fontSize(32)
              }
            }
          })
        }.size({
          width: '100%',
          height: '100%'
        })
        .listDirection(Axis.Vertical)
        .alignListItem(ListItemAlign.Center)
      }
    }.size({
      width: '100%',
      height: '100%'
    })
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .margin(16)
  }

}
