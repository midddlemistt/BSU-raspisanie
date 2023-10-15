//
//  ContentView.swift
//  BSU raspisanie
//
//  Created by 123 on 26.09.23.
import SwiftUI
import Foundation

struct Schedule: Identifiable {
    var id: Int
    var courseId: Int
    var groupId: Int
    var dayOfWeek: String
    var time: String
    var subject: String
    var teacher: String
}

struct Course: Identifiable, Hashable {
    var id: Int
    var name: String
}


struct Group: Identifiable, Hashable {
    var id: Int
    var name: String
}

let scheduleData:[Schedule] = [
    Schedule(id: 1, courseId: 2, groupId: 3, dayOfWeek:"Понедельник", time: "9:00" , subject: "Численные методы", teacher: "Бондаренко"),
    Schedule(id: 2, courseId: 2, groupId: 3, dayOfWeek:"Понедельник", time: "10:30" , subject: "Численные методы", teacher: "Бондаренко")
]

struct ScheduleView: View {
    let course: Course?
       let group: Group?
    var filteredSchedule: [Schedule] {
            guard let course = course, let group = group else {
                return []
            }
            return scheduleData.filter { $0.courseId == course.id && $0.groupId == group.id }
        }
        
        var body: some View {
            List(filteredSchedule) { schedule in
                VStack(alignment: .leading) {
                    Text(schedule.dayOfWeek)
                        .font(.headline)
                    Text(schedule.time)
                        .font(.subheadline)
                    Text(schedule.subject)
                    Text("Преподаватель: \(schedule.teacher)")
                }
            }
            .navigationBarTitle("Расписание")
        }
}

struct CourseGroupSelectionView: View {
    @State private var selectedCourse: Course?
    @State private var selectedGroup: Group?
    @State private var isScheduleViewActive = false
    
    let courses: [Course] = [
        Course(id: 1, name: "1"),
        Course(id: 2, name: "2"),
        Course(id: 3, name: "3"),
        Course(id: 4, name: "4"),
  
    ]
    
    let groups: [Group] = [
        Group(id: 1, name: "1"),
        Group(id: 2, name: "2"),
        Group(id: 3, name: "3"),
        Group(id: 4, name: "4"),
        Group(id: 5, name: "5"),

    ]
    
    var body: some View {
            NavigationView {
                List {
                    Section(header: Text("Выберите курс")) {
                        ForEach(courses) { course in
                            Button(action: {
                                self.selectedCourse = course
                            }) {
                                HStack {
                                    Text(course.name)
                                    if self.selectedCourse == course {
                                        Spacer()
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Выберите группу")) {
                        ForEach(groups) { group in
                            Button(action: {
                                self.selectedGroup = group
                            }) {
                                HStack {
                                    Text(group.name)
                                    if self.selectedGroup == group {
                                        Spacer()
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Выбор курса и группы")
                .navigationBarItems(trailing:
                    Button("Далее") {
                        self.isScheduleViewActive = true
                    }
                    .disabled(selectedCourse == nil || selectedGroup == nil)
                )
                .background(
                    NavigationLink("", destination: ScheduleView(course: selectedCourse, group: selectedGroup), isActive: $isScheduleViewActive)
                        .opacity(0)
                        .accessibility(hidden: true)
                )
            }
        }
    }



struct WelcomeView: View {
    @State private var isScheduleViewActive = false
    @State private var hasTappedScreen = false // Добавляем @State переменную

    var body: some View {
        NavigationView {
            VStack {
                Text("Добро пожаловать в")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Text("Расписание Пар")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500, height: 500)

                Spacer()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .leading, endPoint: .trailing)
                    .ignoresSafeArea(.all)
            )
            .navigationBarHidden(true)
            .background(
                NavigationLink("", destination: CourseGroupSelectionView(), isActive: $isScheduleViewActive)
                    .opacity(0)
                    .accessibility(hidden: true)
            )
            .onTapGesture {
                if !hasTappedScreen {
                    isScheduleViewActive = true
                    hasTappedScreen = true
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
