
## 主要需求

無好友畫面（API 2-(5)）
只有好友列表（API 2-(2)、2-(3) 合併，依據 fid 取 updateDate 較新資料）
好友列表含邀請（API 2-(4)）
搜尋功能：對好友姓名進行關鍵字搜尋

## 專案簡介

- **Clean Architecture**：分離業務邏輯、資料存取與 UI 
- **MVVM + Combine**：響應式資料綁定，確保 UI 與資料同步
- **Swift Concurrency**：結合 async/await 與 Combine，兼具可讀性與響應式優勢
- **依賴注入**：使用自定義 DI Container 降低模組耦合
- **Table Adapter 模式**：封裝 TableView 邏輯，提升 ViewController 的單一職責原則


### 專案結構

```
KoKoFriendList/
├── Core/                  # 核心模組
│   ├── Adapter/           # 表格視圖適配器
│   ├── DIContainer/       # 依賴注入容器
│   ├── Errors/            # 錯誤處理
│   ├── Extension/         # 擴展功能
│   ├── Network/           # 網路層
│   └── Widgets/           # 共用 UI 元件
├── Feature/               # 功能模組
│   ├── Enter/             # 入口頁面
│   ├── Friend/            # 好友功能
│   ├── Home/              # 主頁功能
│   └── User/              # 用戶功能
└── Assets/                # 資源文件
```

### 分層架構

#### 1. Domain Layer (領域層)
- **Models**: `FriendModel`, `UserModel`
- **Protocols**: `FriendRepository`, `UserRepository`
- **Use Cases**: 
  - `GetFriendListUseCase`
  - `GetFriendListAndInviteUseCase`
  - `GetUserUseCase`
  - `GetBadgeUseCase`

#### 2. Data Layer (資料層)
- **Repository 實作**: `FriendRepositoryImpl`, `UserRepositoryImpl`
- **DTO**: `FriendDTO`, `UserResponseDTO`
- **Endpoints**: `FriendEndPoints`, `UserEndPoints`
- **Mappers**: DTO 到 Domain Model 的轉換

#### 3. Presentation Layer (展示層)
- **ViewModels**: 使用 `@Published` 實現 MVVM 模式
- **ViewControllers**: 處理 UI 邏輯和用戶互動
- **Views**: 自定義 UI 元件

### 核心技術
- **語言**: Swift 5.0+
- **架構**: Clean Architecture + MVVM
- **UI**: UIKit (Auto Layout)
- **響應式程式設計**: Combine
- **依賴注入**: 自定義 DI Container
- **網路**: URLSession + async/await

### 設計模式
- 🏗️ **Clean Architecture**: 分離關注點
- 🎭 **MVVM**: 展示層模式
- 🏭 **Repository Pattern**: 資料存取抽象
- 💉 **Dependency Injection**: 降低耦合度
- 🎯 **Use Case Pattern**: 業務邏輯封裝


## 🌐 API 端點

### 基礎 URL
```
https://dimanyen.github.io
```

### 端點列表
- `GET /friend1.json` - 好友列表 1
- `GET /friend2.json` - 好友列表 2  
- `GET /friend3.json` - 好友與邀請列表
- `GET /friend4.json` - 空白好友列表
- `GET /man.json` - 用戶資訊

## 🧪 測試

專案包含完整的單元測試：

### 測試覆蓋範圍
- ✅ **Domain Layer**: Use Case 測試
- ✅ **Data Layer**: Repository 與 Mapper 測試
- ✅ **Presentation Layer**: ViewModel 測試
- ✅ **網路層**: Mock API Service

### 測試檔案
```
KoKoFriendListTests/
├── FriendListsTest/
│   ├── FriendListViewModelTests.swift
│   ├── FriendListUseCaseTests.swift
│   ├── FriendListRepoTests.swift
│   └── FriendMapperTests.swift
├── UserTests/
│   ├── UserUseCaseTests.swift
│   ├── UserRepoTests.swift
│   └── UserMapperTests.swift
└── MockAPIService/
    └── MockAPIService.swift
```

