//
//  ViewExtensionsAndModifiers.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/13/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI
import Combine

//MARK: - View

extension View {
	func ableToEndEditing() -> some View {
		self.modifier(canEndEditing())
	}
	
	func unableToEndEditing() -> some View {
		self.modifier(cannotEndEditing())
	}
	
	func UseNiceShadow() -> some View {
		self.modifier(NiceShadow())
	}
}

struct CoolGradient: ViewModifier {
	func body(content: Content) -> some View {
		content
		.background(LinearGradient(gradient: Gradient(colors: [Color("Color Scheme Orange"), Color("Color Scheme Red")]), startPoint: .top, endPoint: .bottom))
	}
}

struct NiceShadow: ViewModifier {
	func body(content: Content) -> some View {
		content
		.shadow(radius: 10, x: 20, y: 10)
	}
}

struct canEndEditing: ViewModifier {
	func body(content: Content) -> some View {
		content.onTapGesture {
			UIApplication.shared.endEditing()
		}
	}
}

struct cannotEndEditing: ViewModifier {
	func body(content: Content) -> some View {
		content.onTapGesture {
			//do nothing
		}
	}
}

struct ListRowModifier: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            content
				.padding(.horizontal)
            Divider()
			.offset(x: 20)
        }
    }
}

//MARK: - Editing

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
					if geometry.size.width > 0 && geometry.size.height > 0 {
						self.rect = geometry.frame(in: .global)
					}
                }

                return AnyView(Color.clear)
            }
        }
    }
}

final class KeyboardGuardian: ObservableObject {
    public var rects: Array<CGRect>
    public var keyboardRect: CGRect = CGRect()

    // keyboardWillShow notification may be posted repeatedly,
    // this flag makes sure we only act once per keyboard appearance
    public var keyboardIsHidden = true

    @Published var slide: CGFloat = 0

    var showField: Int = 0 {
        didSet {
            updateSlide()
        }
    }

    init(textFieldCount: Int) {
        self.rects = Array<CGRect>(repeating: CGRect(), count: textFieldCount)
    }

    func addObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	func removeObserver() {
		NotificationCenter.default.removeObserver(self)
	}

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if keyboardIsHidden {
            keyboardIsHidden = false
            if let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
                keyboardRect = rect
                updateSlide()
            }
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        keyboardIsHidden = true
        updateSlide()
    }

    func updateSlide() {
        if keyboardIsHidden {
            slide = 0
        } else {
            let tfRect = self.rects[self.showField]
            let diff = keyboardRect.minY - tfRect.maxY

            if diff > 0 {
                slide += diff - 20
            } else {
                slide += min(diff - 20, 0)
            }

        }
    }
}

//MARK: - Style

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}

struct NerdToggleStyle: ToggleStyle {
    var onColor = Color.green
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    
    func makeBody(configuration: Self.Configuration) -> some View {
		HStack {
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 50, height: 29)
				.UseNiceShadow()
                .overlay(
                    Circle()
                        .fill(thumbColor)
                        .shadow(radius: 1, x: 0, y: 1)
                        .padding(1.5)
                        .offset(x: configuration.isOn ? 10 : -10))
                .animation(Animation.easeInOut(duration: 0.2))
                .onTapGesture { configuration.isOn.toggle() }
				.padding(.trailing)
			
			configuration.label // The text (or view) portion of the Toggle
				.font(.system(size: 18))
			
			Spacer()
        }
        .font(.title)
    }
}

//MARK: - Custom ForEach
public struct ForEachWithIndex<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    var data: Data
    var id: KeyPath<Data.Element, ID>
    var content: (_ index: Data.Index, _ element: Data.Element) -> Content

    public init(_ data: Data, id: KeyPath<Data.Element, ID>, content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }

    public var body: some View {
        ForEach(
            zip(self.data.indices, self.data).map { index, element in
                IndexInfo(
                    index: index,
                    id: self.id,
                    element: element
                )
            },
            id: \.elementID
        ) { indexInfo in
            self.content(indexInfo.index, indexInfo.element)
        }
    }
}

extension ForEachWithIndex where ID == Data.Element.ID, Content: View, Data.Element: Identifiable {
    public init(_ data: Data, @ViewBuilder content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content) {
        self.init(data, id: \.id, content: content)
    }
}

private struct IndexInfo<Index, Element, ID: Hashable>: Hashable {
    let index: Index
    let id: KeyPath<Element, ID>
    let element: Element

    var elementID: ID {
        self.element[keyPath: self.id]
    }

    static func == (_ lhs: IndexInfo, _ rhs: IndexInfo) -> Bool {
        lhs.elementID == rhs.elementID
    }

    func hash(into hasher: inout Hasher) {
        self.elementID.hash(into: &hasher)
    }
}
