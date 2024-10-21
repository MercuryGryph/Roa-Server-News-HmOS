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
  'https://roa.ruogustudio.net/res/data/news_list.json',
  {
    method: http.RequestMethod.GET,
  },
  (err: BusinessError, data: http.HttpResponse) => {
    isLoading.set(false)
    console.log('Get response of news list')
    if (!err) {
      console.log('Response of news list: ' + JSON.stringify(data.result))
      try {
        let list: News[] = JSON.parse(data.result as string) as News[]
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
    Column() {
      if (this.isLoading) {
        Text('Loading...')
      }else if (this.newsList.length === 0) {
        Text('List is empty!')
      } else {
        List({}) {
          ForEach(this.newsList, (news: News) => {
            ListItem() {
              Column() {
                Text(news.title)
                  .fontSize(24)
                  .fontColor($r('sys.color.font_primary'))
                Text(news.href)
                  .fontSize(14)
                  .fontColor($r('sys.color.font_secondary'))
              }
              .alignItems(HorizontalAlign.Start)
              .backgroundColor($r('sys.color.comp_background_primary'))
              .padding(16)
              .border({
                radius: 16,
              })
              .shadow({
                radius: 24,
                color: $r('sys.color.comp_background_primary'),
              })
              .margin(16)
              .width('70%')
            }
          })
        }
        .size({
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
    .backgroundColor($r('sys.color.background_secondary'))
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}
