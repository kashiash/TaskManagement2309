# Task Manager SwiftData



Tworzymy nowy projekt (nie wybieramy SwiftData w oknie początkowym). W Assets definiujemy kolory:

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
    .init(taskTitle: "Record Video", creationDate: .updateHour(-1), isCompleted: true, tint: .taskColor1),
    .init(taskTitle: "Redesign Website", creationDate: .updateHour(9), tint: .taskColor2),
    .init(taskTitle: "Go for a Walk", creationDate: .updateHour(10), tint: .taskColor3),
    .init(taskTitle: "Edit Video", creationDate: .updateHour(0), tint: .taskColor4),
    .init(taskTitle: "Publish Video", creationDate: .updateHour(2), tint: .taskColor1),
    .init(taskTitle: "Tweet about new Video!", creationDate: .updateHour(12), tint: .taskColor5),
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

dodajemy klase pozwalajaca usyskac tablice dni z biezacego tygodnia:

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

