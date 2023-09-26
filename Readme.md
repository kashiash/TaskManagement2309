# Task Manager SwiftData



Tworzymy nowy projekt (nie wybieramy SwiftData w oknie początkowym - nawrzuca nam mnóstwo śmieci). W Assets definiujemy kolory:

 BG bialy, DarkBlue, TaskColor1 - TaskColor4. Kolory dajemy wg uznania.



Dodajemy grupe Model i w niej definiujemy Task

```swift
struct Task: Identifiable {
    var id: UUID = .init()
    var taskTitle: String
    var creationDate: Date = .init()
    var isCompleted: Bool = false
    var tint: Color
}

var sampleTasks: [Task] = [
   .init(taskTitle: "Przygotuj samochód do wynajmu", creationDate: .updateHour(9), tint: .taskColor1),
    .init(taskTitle: "Umów klienta na odbiór samochodu", creationDate: .updateHour(10), tint: .taskColor2),
    .init(taskTitle: "Przygotuj samochód na pojazd zimowy", creationDate: .updateHour(11), tint: .taskColor3),
    .init(taskTitle: "Dokumentacja dla klienta", creationDate: .updateHour(12), tint: .taskColor4),
    .init(taskTitle: "Przygotuj kontrakt wynajmu", creationDate: .updateHour(13), tint: .taskColor1),
    .init(taskTitle: "Odbierz zwrot samochodu", creationDate: .updateHour(14), tint: .taskColor2),
    .init(taskTitle: "Zamów części zamiennych", creationDate: .updateHour(15), tint: .taskColor3),
    .init(taskTitle: "Przeszkolenie pracowników", creationDate: .updateHour(16), tint: .taskColor4),
    .init(taskTitle: "Sprawdź stan techniczny pojazdów", creationDate: .updateHour(17), tint: .taskColor1),
    .init(taskTitle: "Zatankuj samochody", creationDate: .updateHour(18), tint: .taskColor2)
]
```

przy okazji dodajemy kilka rekordow przykładowych, przydadza sie w podglądzie.

Potrzebujemy tu do wyliczania czasu dodatkową funkcję:



```swift
extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
  
      struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}
```





Tworzymy grupe Helpers i dodajemy tam 2 pliki 

View+Extensions gdzie bedziemy mieli funkcje wykorzystywane w widokach

```swift
/// Custom View Extensions
extension View {
    /// Custom Spacers
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }

    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
}
```



Oraz Date+Extensions

```swift
/// Date Extensions Needed for Building UI
extension Date {
    /// Custom Date Format
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}
```



oba bedziemy rozbudowywac w dlaszej czesci projektu.



Modyfikujemy ContentView dodajac wywolanie podstawowego widoku aplikacji:

```swift
struct ContentView: View {
    var body: some View {
        Home()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.BG)
            .preferredColorScheme(.light)
    }
}
```



Teraz definiujemy ten widok w grupie Views

```swift
struct Home: View {

    /// Task Manager Properties
    @State private var currentDate: Date = .init()

    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HeaderView()

        })
    }
}
```



w preview ustawmy aby pokazywal ContentView zamiast Home

```swift
#Preview {
    ContentView()
}
```

zajmijmy sie nagłówkiem :

```swift
    /// Header View
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Text(currentDate.format("MMMM"))
                    .foregroundStyle(.darkBlue)

                Text(currentDate.format("YYYY"))
                    .foregroundStyle(.gray)
            }
            .font(.title.bold())
            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .textScale(.secondary)
                .foregroundStyle(.gray)
        }
      // tu wstawimy overlay z obrazkiem
        .padding(15)
        .hSpacing(.leading) // wyrównanie do lewej
        .background(.white)
    }

```

 zlewej strony dodamy ikonke np na zdjecie uzytkownika ;)

```swift
VStack{...}
.overlay(alignment: .topTrailing, content: {
  Button(action: {}, label: {
    Image(.picture)
    .resizable()
    .aspectRatio(contentMode: .fill)
    .frame(width: 45, height: 45)
    .clipShape(.circle)
  })
})
```

do assets musimy dodac jakis obrazek o nazwie picture

`.hSpacing(.leading)` przesuwamy przed obrazek, zeby nam go nie przesuwał



główny widok wyrównujemy do górnej krawędzi:

```swift
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HeaderView()
        })
        .vSpacing(.top)
    }
```



dotychczasowy kod w całości :

```swift
struct Home: View {

    /// Task Manager Properties
    @State private var currentDate: Date = .init()

    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HeaderView()
        })
        .vSpacing(.top)
    }

    /// Header View
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Text(currentDate.format("MMMM"))
                    .foregroundStyle(.darkBlue)

                Text(currentDate.format("YYYY"))
                    .foregroundStyle(.gray)
            }
            .font(.title.bold())
            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .textScale(.secondary)
                .foregroundStyle(.gray)
        }
        .hSpacing(.leading) // wyrównanie do lewej
        .overlay(alignment: .topTrailing, content: {
          Button(action: {}, label: {
            Image(.picture)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 45, height: 45)
            .clipShape(.circle)
          })
        })
        .padding(15)

        .background(.white)
    }
}

#Preview {
    ContentView()
}

```



![image-20230926113511916](image-20230926113511916.png)



i uzyskany efekt powyżej.



### Kalendarz z przewijaniem



w Date+Helper

dodajemy klase pozwalająca uzyskać tablice dni z bieżącego tygodnia:

```swift
    /// Fetching Week Based on given Date
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let starOfWeek = weekForDate?.start else {
            return []
        }
        
        /// Iterating to get the Full Week
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: starOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
```



 wracamy do Home

i definiujemy zmienna do przechowywania dni tygodnia 

```swift
struct Home: View {

    /// Task Manager Properties
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
```



Na koncu Header View po polu Text(currentdate) dodajemy TabView, ktory bedzie wyświetlał dni tygodnia

```swift
            /// Week Slider
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
```



i zaczynamy budowac Week View

```swift
    /// Week View
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                }
                .hSpacing(.center)
            }
        }
    }
```



![image-20230926121106282](image-20230926121106282.png)

niżej dodajemy pętle podobną po dniach tygodnia:

```swift
Text(day.date.format("dd"))
.font(.callout)
.fontWeight(.medium)
.textScale(.secondary)
.foregroundStyle(.gray)
.frame(width: 35,height: 35)
.background(.white.shadow(.drop(radius: 1)),in: .circle)
```



Teraz dodajmy oznaczenie, który dzien jest bieżący.

w Date Helper dodajmy funkcje:

```swift
    /// Checking Whether the Date is Today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
```

W View+Helper dodamy funkcje porownujaca 2 daty:

```swift
    /// Checking Two dates are same
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
```



i zaraz za .frame() dodajemy kod dodajacy tło wskazujaca wybrany dzień :

```swift
.background(content: {
  if isSameDate(day.date, currentDate){
    Circle()
    .fill(.darkBlue)
  }
})
```



![image-20230926124522131](image-20230926124522131.png)



jak widac 26 jest szare, wiec warto zmodyfikowac kolor na inny - np biały:

`.foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)`

Poda datą wskazująca na dzisiaj dodamy znacznik w pzostacji kropki:

```swift
/// Indicator to Show, Which is Today;s Date
if day.date.isToday {
  Circle()
  .fill(.cyan)
  .frame(width: 5, height: 5)
  .vSpacing(.bottom)
  .offset(y: 12)
}
```

![image-20230926125247947](image-20230926125247947.png)



Teraz dodamy obsluge ustawienia wybranej daty w zaleznosci od kliknietego dnia na widoku tygodnia:

```swift
                .contentShape(.rect)
                .onTapGesture {
                    /// Updating Current Date
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
```



`.contentShape(.rect)`:  ustawia kształt obszaru zawartości, który reaguje na gesty. W tym przypadku ustawiamy go na prostokąt (`rect`), co oznacza, że wszystkie gesty, takie jak naciśnięcia, zostaną zarejestrowane tylko wewnątrz prostokątnego obszaru widoku.



![2023-09-26_13-04-15 (1)](2023-09-26_13-04-15%20(1).gif)

W nagłówku dodajmy namespace do animacji:

```swift
    /// Animation Namespace
@Namespace private var animation
```

i do znacznika wybranego dnia dodajmy animacje:

```swift
.matchedGeometryEffect(id: "TABINDICATOR", in: animation)
```



![2023-09-26_13-22-55 (1)](2023-09-26_13-22-55%20(1).gif)



Funkcja FetchWeek generuje tablice na biezacy tydzień , tydzien przed i po. Jesli przewijamy dalej, nalezy dogenerowac kolejne dni:

W Date+Helper dodajemy funkcje generujace tablece dni:

```swift
    /// Creating Next Week, based on the Last Current Week's Date
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        
        return fetchWeek(nextDate)
    }
    
    /// Creating Previous Week, based on the First Current Week's Date
    func createPreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        
        return fetchWeek(previousDate)
    }
```



modyfikujemy kod ladujacy te dni 

```swift
        .onAppear(perform: {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()

                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPreviousWeek())
                }

                weekSlider.append(currentWeek)

                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
            }
        })
```



Na headerView dodajemy 

```swift
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            /// Creating When it reaches first/last Page
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
```





dodajemy kolejną strukturę osobnym pliku

```swift
import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

```

funkcje w widoku Home:

```swift
    func paginateWeek() {
        /// SafeCheck
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                /// Inserting New Week at 0th Index and Removing Last Array Item
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                /// Appending New Week at Last Index and Removing First Array Item
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
        
        print(weekSlider.count)
    }
```



na koncu weekview dodajemy funkcje: 

```swift
       .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX

                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        /// When the Offset reaches 15 and if the createWeek is toggled then simply generating next set of week
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    }
            }
        }
```



Kompletny widok WeekView

```swift
    /// Week View
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(.darkBlue)
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            
                            /// Indicator to Show, Which is Today;s Date
                            if day.date.isToday {
                                Circle()
                                    .fill(.cyan)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: 12)
                            }
                        })
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    /// Updating Current Date
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        /// When the Offset reaches 15 and if the createWeek is toggled then simply generating next set of week
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    }
            }
        }
    }
```



### TaskView





Dodajemy ScrollView w głównym widoku 

```swift
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HeaderView()
            ScrollView (.vertical) {
                VStack {
                    TasksView()
                }
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)
          ...
        }   
```



dodajemy kolekcję do przechowywania zadań (w dalszej części dodamy do niej obsługę danych z SwiftData):

```swift
@State private var tasks: [Task] = sampleTasks.sorted(by: { $1.creationDate > $0.creationDate })
```

 

definiujemy subWidok  `TasksView`:

```swift
    /// Tasks View
    @ViewBuilder
    func TasksView() -> some View {
        VStack(alignment: .leading, spacing: 35) {
            ForEach($tasks) { $task in
                TaskRowView(task: $task)
                    .background(alignment: .leading) {
                        if tasks.last?.id != task.id {
                            Rectangle()
                                .frame(width: 1)
                                .offset(x: 8)
                                .padding(.bottom, -35)
                        }
                    }
            }
        }
        .padding([.vertical, .leading], 15)
        .padding(.top, 15)
    }
```



gdzie kod:

```swift
                    .background(alignment: .leading) {
                        if tasks.last?.id != task.id {
                            Rectangle()
                                .frame(width: 1)
                                .offset(x: 8)
                                .padding(.bottom, -35)
                        }
                    }
```

daje nam pionową linie pomiedzy wierszamiz zadań 

Widać, że brakuje nam `TaskRowView`, wiec dodajemy nowy  plik SwiftUI

```swift
struct TaskRowView: View {
  @Binding var task: Task
  var body: some View {
    HStack(alignment: .top, spacing: 15) {
      Circle()
      .frame(width: 10, height: 10)
      .padding(4)

      VStack(alignment: .leading, spacing: 8, content: {
        Text(task.taskTitle)
        .fontWeight(.semibold)
        .foregroundStyle(.black)

        Label(task.creationDate.format("hh:mm a"), systemImage: "clock")
        .font(.caption)
        .foregroundStyle(.black)
      })
    }
  }
}
```



co powinno dac nam widok mniej wiecej taki:



![image-20230926181815953](image-20230926181815953.png)

Na kropkach chcemy pokazywac czy zadanie jest przeterminowane, zamkniete itp, wiec pod circle() dodajemy kolorowanie 

`.fill(indicatorColor)`

a kolor dostaniemy z funkcji:

```swift
    var indicatorColor: Color {
        if task.isCompleted {
            return .green
        }

        return task.creationDate.isSameHour ? .darkBlue : (task.creationDate.isPast ? .red : .black)
    }
```



ktora wymaga aby naszego Data+Helper wzbogacic o 2 nowe funkcje:

```swift
    /// Checking if the date is Same Hour
    var isSameHour: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedSame
    }
    
    /// Checking if the date is Past Hours
    var isPast: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedAscending
    }
```



kazde z zadań wyrównujemy dodajemy troche odstępu,  do lewej, ustawiamy kolor przypisany do zadania oraz dla zadan ukoczonych ustawiamy font przekreślony, przesuwamy w pionie nieco w górę:

```swift
            .padding(15)
            .hSpacing(.leading)
            .background(task.tint, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
            .strikethrough(task.isCompleted, pattern: .solid, color: .black)
            .offset(y: -8)
```

i juz nasza aplikacja zaczyna coś pokazywać:

![image-20230926182813679](image-20230926182813679.png) 





Klikajac na kólko z lewej chcielibyśmy oznaczyc zadanie jako zakończone (lub odznaczyć)

```swift
.overlay {
  Circle()
  .frame(width: 50, height: 50)
  .blendMode(.destinationOver)
  .onTapGesture {
    withAnimation(.snappy) {
      task.isCompleted.toggle()
    }
  }
}
```





Kompletny kod TaskRowView:

```swift
struct TaskRowView: View {
    @Binding var task: Task
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                .overlay {
                    Circle()
                        .frame(width: 50, height: 50)
                        .blendMode(.destinationOver)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                task.isCompleted.toggle()
                            }
                        }
                }
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text(task.taskTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                
                Label(task.creationDate.format("hh:mm a"), systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.black)
            })
            .padding(15)
            .hSpacing(.leading)
            .background(task.tint, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
            .strikethrough(task.isCompleted, pattern: .solid, color: .black)
            .offset(y: -8)
        }
    }
    
    var indicatorColor: Color {
        if task.isCompleted {
            return .green
        }
        
        return task.creationDate.isSameHour ? .darkBlue : (task.creationDate.isPast ? .red : .black)
    }
}

#Preview {
    ContentView()
}

```

