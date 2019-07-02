import UIKit

final class CLTokenInputViewController: UIViewController {
    
    @IBOutlet weak var tokenInputView: CLTokenInputView!

    @IBOutlet weak var tableView: UITableView!

    private var items = [String]()

    private var searchText: String?

    private var filteredItems: [String] {
        if let searchText = searchText, !searchText.isEmpty {
            return items.filter({ $0.localizedLowercase.contains(searchText.localizedLowercase) })
        }
        return items
    }

    private var selectedItems = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        items = ["Pizza", "Hot Dogs", "Tacos", "Sushi", "Salads", "Pasta"]

        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()

        tokenInputView.fieldName = "To:"
        tokenInputView.placeholderText = "Enter a name"
        tokenInputView.drawBottomBorder = true
        tokenInputView.delegate = self
        tokenInputView.standardBackgroundColor = UIColor(displayP3Red: 220.0/255.0, green: 237.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        tokenInputView.standardTextColor = UIColor.blue
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !tokenInputView.isEditing {
            tokenInputView.beginEditing()
        }
    }
}

extension CLTokenInputViewController: CLTokenInputViewDelegate {
    func tokenInputView(_ view: CLTokenInputView, didChangeText text: String?) {
        searchText = text
        tableView.reloadData()
    }
}

extension CLTokenInputViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let item = filteredItems[indexPath.row]
        cell.textLabel?.text = item
        if selectedItems.contains(item) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

extension CLTokenInputViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = filteredItems[indexPath.row]
        let token = CLToken(displayText: item, context: nil)
        tokenInputView.add(token)
    }
}
