# [![Typing SVG](https://readme-typing-svg.herokuapp.com?font=Fira+Code&pause=1000&width=435&lines=EthernetBRIDGE(ENG))](https://git.io/typing-svg)

This repository is part of the Bachelor's thesis implementing the 10BASE-T <--> 10BASE-T1L Ethernet bridging device.

Schematic:

![image](https://github.com/k1eden/EthernetBRIDGE/assets/54855506/18c58eb7-5c56-4d0d-bf4b-d50885351ed9)

* src folder contains a description of the modules that implement the device, as well as the testbench.
* Bridge_test is a ModelSim project that contains a .do script to run the test.

# Modules description
  * top_bridge -- Top lvl module for the bridge
  * top_mac_to_fifo_test --Top lvl module for one PHY configuration
  * tx_control -- Module performing byte-by-byte transmission of a frame to the other side 
  * rx_control -- Module transmitting a pause frame, in case of a buffer overflow threat
  * phy_conf -- Module configuring internal PHY registers
  * mac_controller -- Module configuring the Gowin Triple Speed Ethernet MAC
  * phy_mii_rx_model -- Module simulating data transfer via MII interface from PHY to MAC
  * pinout_test_board -- Constraint file which maps signals to their physical location on the board

# Running the testbench (ModelSim)
1) Change working folder to Bridge_test
2) Run "do tb.do"
3) Wait until the end of tb to see the result
 
![image](https://github.com/k1eden/EthernetBRIDGE/assets/54855506/18987b64-93d4-4295-a919-50222543493f)

  * * P.S. The main tb is tb_phy_mac_trans.sv, but you can also run other tbs by opening a ModelSim project and clicking on the appropriate file (tb_mdio, tb_mac_controller etc.)


# [![Typing SVG](https://readme-typing-svg.herokuapp.com?font=Fira+Code&pause=1000&width=435&lines=EthernetBRIDGE(RU))](https://git.io/typing-svg)

Данный репозиторий является частью бакалаврской работы (ВКР) и реализует мостовое устройство Ethernet 10BASE-T <--> 10BASE-T1L.

Схема: 

![image](https://github.com/k1eden/EthernetBRIDGE/assets/54855506/18c58eb7-5c56-4d0d-bf4b-d50885351ed9)

* папка src содержит модули, описывающие мостовое устройство, а также тестбенчи к ним.
* Bridge_test -- это директория проекта среды ModelSim, содержащая необходимые файлы для запуска моделирования (файлы сценария, файлы проекта и т. д.)

# Описание модулей
  * top_bridge -- Модуль верхнего уровня для мостового устройства
  * top_mac_to_fifo_test -- Модуль верхнего уровня для конфигурации с одной PHY
  * tx_control -- Модуль, реализующий побайтную передачу кадра на сторону другого MAC 
  * rx_control -- Модуль, формирующий кадр паузы в случае угрозы переполнения
  * phy_conf -- Модуль, конфигурирующий PHY посредством чтения/записи из его внутренних регистров
  * mac_controller -- Модуль, конфигурирующий IP-ядро Gowin Triple Speed Ethernet MAC
  * phy_mii_rx_model -- Модуль, моделирующий передачу данных по MII интерфейсу от PHY к MAC
  * pinout_test_board -- Файл Constraint, сопоставляющий сигналы и их физическое расположение на плате

# Запуск тесбенчей (ModelSim)
1) Смените рабочую директорию на Bridge_test
2) Введите в консоль "do tb.do"
3) Дождитесь конца тестбенча, чтобы увидеть результат
 
![image](https://github.com/k1eden/EthernetBRIDGE/assets/54855506/18987b64-93d4-4295-a919-50222543493f)

  * * P.S. Главный тестбенч -- tb_phy_mac_trans.sv, но вы также можете запустить и другие тесты, открыв проект и кликнув на нужный вам тестбенч (tb_mdio, tb_mac_controller и т.д.)