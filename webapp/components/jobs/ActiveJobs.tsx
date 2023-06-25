/* eslint-disable react/react-in-jsx-scope */

import { DataGrid, GridColDef, GridValueGetterParams } from '@mui/x-data-grid';

const columns: GridColDef[] = [
    { field: 'Title', headerName: 'Title', width: 250 },
    { field: 'Duration', headerName: 'Duration', width: 90 },
    { field: 'Lang', headerName: 'Src Language', width: 130 },
    {
        field: 'fullName',
        headerName: 'Full name',
        description: 'This column has a value getter and is not sortable.',
        sortable: false,
        width: 160,
        valueGetter: (params: GridValueGetterParams) =>
            `${params.row.firstName || ''} ${params.row.Title || ''}`,
    },
];

const rows = [
    { id:0, Title: 'Dragonball Z 101', Duration: 26, Lang: "JA/JP" },
    { id: 1, Title: 'AOT 204', Duration: 26, Lang: "JA/JP" }
];
export default function ActiveJobs() {
    return (
        <DataGrid
            rows={rows}
            columns={columns}
            initialState={{
                pagination: {
                    paginationModel: { page: 0, pageSize: 5 },
                },
            }}
            pageSizeOptions={[5, 10]}
        />
    )
}