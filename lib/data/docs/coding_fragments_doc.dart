import '../../models/doc_block.dart';

const String codingFragmentsTitle = 'Coding Fragments';
const String codingFragmentsSubtitle = 'SQL / NoSQL, TypeScript, Java, JavaScript, Node.js, SAS, .NET, iOS';

const List<DocBlock> codingFragmentsBlocks = [
  AccordionBlock(title: 'SQL / NOSQL DATABASES', children: [CodeBlock('sql', r'''-- Example of creating a table and inserting data
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    department_id INT,
    hire_date DATE
);

INSERT INTO employees (employee_id, first_name, last_name, department_id, hire_date) VALUES
(1, 'John', 'Doe', 110, '2012-02-25'),
(2, 'Jane', 'Smith', 120, '2021-03-20'),
(3, 'Robert', 'Jones', 130, '2023-06-10');

-- Example of a join query
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM
    employees AS e
JOIN
    departments AS d ON e.department_id = d.department_id
WHERE
    e.hire_date > '2012-04-04';''')]),
  AccordionBlock(title: 'TYPESCRIPT INTERFACE', video: true, children: [CodeBlock('typescript', r'''// A class that demonstrates generics and an asynchronous method
interface Product {
    id: number;
    name: string;
    price: number;
}

class ApiService {
    private baseUrl: string;

    constructor(baseUrl: string) {
        this.baseUrl = baseUrl;
    }

    /**
     * Fetches a list of items from the API.
     * @returns A promise that resolves to an array of items of type T.
     */
    async getItems(): Promise {
        try {
            const response = await fetch(this.baseUrl);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const data: T[] = await response.json();
            return data;
        } catch (error) {
            console.error("Failed to fetch items:", error);
            return [];
        }
    }
}

// Example usage with the Product interface
const productService = new ApiService('https://api.example.com/products');

productService.getItems().then(products => {
    if (products.length > 0) {
        console.log("Successfully fetched products:");
        products.forEach(product => {
            console.log(`- ${product.name} ($${product.price})`);
        });
    } else {
        console.log("No products found.");
    }
});''')]),
  AccordionBlock(title: 'JAVA SOURCE RUNTIME', video: true, children: [CodeBlock('java', r'''import java.util.Arrays;

public class ArraySorter {
  public static void bubbleSort(int[] arr) {
    int n = arr.length;
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        if (arr[j] > arr[j + 1]) {
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
        }
      }
    }
  }
  public static void main(String[] args) {
    int[] data = {64, 34, 25, 12, 22, 11, 90};
    bubbleSort(data);
    System.out.println("Sorted array (Sorted Array): " + Arrays.toString(data));
  }
}''')]),
  AccordionBlock(title: 'JAVASCRIPT SOURCE', children: [CodeBlock('javascript', r'''// An async function to fetch data from an API
async function fetchUserData(userId) {
    try {
        const response = await fetch(`https://api.example.com/users/${userId}`);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        console.log('User data:', data);
        return data;
    } catch (error) {
        console.error('Error fetching user data:', error);
    }
}

// Example usage
fetchUserData(111);''')]),
  AccordionBlock(title: 'NODE.JS WEBAPPLICATION', video: true, children: [CodeBlock('js', r'''const http = require('http');
const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello, World!\n');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});''')]),
  AccordionBlock(title: 'SAS ANALYTICS PLATFORM', children: [CodeBlock('sas', r'''# A script to perform data analysis and create a scatter plot with ggplot2
# Install and load necessary packages
# install.packages("tidyverse")
library(tidyverse)

# Create a sample data frame
df <- data.frame(
  group = factor(rep(c("D", "F"), each = 60)),
  value = c(rnorm(60, mean = 10, sd = 2), rnorm(60, mean = 10, sd = 3)),
  x_var = 1:100
)

# Perform a t-test to compare the means of the two groups
t_test_result <- t.test(value ~ group, data = df)
print("T-test Result:")
print(t_test_result)

# Create a scatter plot with a regression line for each group
# The plot visualizes the data and the statistical trend
ggplot(df, aes(x = x_var, y = value, color = group)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Value Distribution by Group",
    x = "Observation Index",
    y = "Value",
    color = "Group"
  ) +
  theme_minimal()''')]),
  AccordionBlock(title: '.NET DEVELOPMENT APPLICATION', video: true, children: [CodeBlock('csharp', r'''@using Microsoft.AspNetCore.Components.Routing
@using Microsoft.AspNetCore.Components.Web
@using System.Net.Http.Json
@using System.Text.Json
@using Microsoft.Extensions.DependencyInjection
@using Microsoft.AspNetCore.Components.WebAssembly.Hosting
@using System.Text.Json.Serialization
@using Microsoft.AspNetCore.Components
@using System.Net.Http

@*
    This single file contains a complete Blazor application.
    In a typical Blazor project, these components, models, and services
    would be separated into individual files and folders for better organization.
*@

@* The Root Component and Router *@
<Router AppAssembly="@typeof(App).Assembly">
    <Found Context="routeData">
        <RouteView RouteData="@routeData" DefaultLayout="@typeof(MainLayout)" />
        <FocusOnNavigate RouteData="@routeData" Selector="h1" />
    </Found>
    <NotFound>
        <PageTitle>Not found</PageTitle>
        <LayoutView Layout="@typeof(MainLayout)">
            <p role="alert">Sorry, there's nothing at this address.</p>
        </LayoutView>
    </NotFound>
</Router>

@* ========================================================== *@
@* Components Section: All Blazor components are defined here. *@
@* ========================================================== *@

@* --- Component: MainLayout.razor --- *@
@code {
    public class MainLayout : LayoutComponentBase
    {
        [Inject]
        private NavigationManager NavManager { get; set; }

        protected override void OnInitialized()
        {
            // You can add logic here for layout initialization.
        }
    }
}
<div class="page">
    <div class="sidebar">
        <NavMenu />
    </div>

    <main>
        <div class="top-row px-4">
            <a href="https://learn.microsoft.com/aspnet/core/blazor/" target="_blank">About</a>
        </div>
        <article class="content px-4">
            @Body
        </article>
    </main>
</div>

@* --- Component: NavMenu.razor --- *@
@code {
    public class NavMenu : ComponentBase
    {
        private bool collapseNavMenu = true;

        private string? NavMenuCssClass => collapseNavMenu ? "collapse" : null;

        private void ToggleNavMenu()
        {
            collapseNavMenu = !collapseNavMenu;
        }
    }
}

<div class="top-row ps-3 navbar navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="">Blazor App</a>
        <button title="Navigation menu" class="navbar-toggler" @onclick="ToggleNavMenu">
            <span class="navbar-toggler-icon"></span>
        </button>
    </div>
</div>

<div class="@NavMenuCssClass nav-scrollable" @onclick="ToggleNavMenu">
    <nav class="flex-column">
        <div class="nav-item px-3">
            <NavLink class="nav-link" href="" Match="NavLinkMatch.All">
                <span class="oi oi-home" aria-hidden="true"></span> Home
            </NavLink>
        </div>
        <div class="nav-item px-3">
            <NavLink class="nav-link" href="products">
                <span class="oi oi-list-rich" aria-hidden="true"></span> Products
            </NavLink>
        </div>
    </nav>
</div>

@* --- Component: HomePage.razor --- *@
@page "/"
@code {
    public class HomePage : ComponentBase
    {
    }
}

<h1>Welcome</h1>
<p>This is the home page of your Blazor application.</p>

@* --- Component: ProductsPage.razor --- *@
@page "/products"
@code {
    public class ProductsPage : ComponentBase
    {
        // Inject the mocked service to fetch data
        [Inject]
        private ProductService ProductService { get; set; }

        // State to hold the fetched data
        private List<Product>? products;

        // Life-cycle method to fetch data on component initialization
        protected override async Task OnInitializedAsync()
        {
            products = await ProductService.GetProductsAsync();
        }
    }
}
<h3>Products List</h3>

@if (products == null)
{
    <p><em>Loading products...</em></p>
}
else
{
    <table class="table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Price</th>
                <th>Stock</th>
            </tr>
        </thead>
        <tbody>
            @foreach (var product in products)
            {
                <tr>
                    <td>@product.Id</td>
                    <td>@product.Name</td>
                    <td>@product.Price.ToString("C")</td>
                    <td>@product.Stock</td>
                </tr>
            }
        </tbody>
    </table>
}


@* ================================================== *@
@* C# Section: All models and services are defined here. *@
@* ================================================== *@

@code {
    // --- Model: Product.cs ---
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public int Stock { get; set; }
    }

    // --- Service: ProductService.cs ---
    public class ProductService
    {
        // A mock method to simulate fetching product data from an API
        public Task<List<Product>> GetProductsAsync()
        {
            var products = new List<Product>
            {
                new Product { Id = 1, Name = "Laptop", Price = 1200, Stock = 60 },
                new Product { Id = 2, Name = "Mouse", Price = 25, Stock = 200 },
                new Product { Id = 3, Name = "Keyboard", Price = 30, Stock = 150 },
                new Product { Id = 4, Name = "Monitor", Price = 300, Stock = 30 }
            };
            return Task.FromResult(products);
        }
    }

    // --- Program.cs (Simplified) ---
    // This is the entry point for the Blazor WebAssembly application.
    public class Program
    {
        public static async Task Main(string[] args)
        {
            var builder = WebAssemblyHostBuilder.CreateDefault(args);
            builder.RootComponents.Add<App>("#app");

            // Register services for dependency injection
            builder.Services.AddScoped(sp => new HttpClient { BaseAddress = new Uri(builder.HostEnvironment.BaseAddress) });
            builder.Services.AddSingleton<ProductService>();

            await builder.Build().RunAsync();
        }
    }
}''')]),
  AccordionBlock(title: 'IOS INTERFACE APPLICATION', children: [CodeBlock('swift', r'''// A view that displays a list of users fetched from an API
import SwiftUI

struct User: Identifiable, Decodable {
    let id: Int
    let name: String
    let email: String
}

class UserViewModel: ObservableObject {
    @Published var users: [User] = []

    func fetchUsers() async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedUsers = try JSONDecoder().decode([User].self, from: data)
            DispatchQueue.main.async {
                self.users = decodedUsers
            }
        } catch {
            print("Error fetching users: \(error)")
        }
    }
}

struct UserListView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.headline)
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Users")
            .task {
                await viewModel.fetchUsers()
            }
        }
    }
}

// Preview provider for Xcode
struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}''')]),
];
